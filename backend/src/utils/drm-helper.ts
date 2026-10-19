/**
 * DRM & ClearKey Encrypted Media Extensions (EME) Helper for Browser Video Playback
 */

export interface ClearKeyConfig {
  kid: string;
  key: string;
}

/**
 * Converts a hex string into a Uint8Array
 */
export function hexToBytes(hex: string): Uint8Array {
  const cleanHex = hex.replace(/[^0-9a-fA-F]/g, '');
  const bytes = new Uint8Array(Math.floor(cleanHex.length / 2));
  for (let i = 0; i < bytes.length; i++) {
    bytes[i] = parseInt(cleanHex.substr(i * 2, 2), 16);
  }
  return bytes;
}

/**
 * Converts a Uint8Array into a base64url string (RFC 7515)
 */
export function bytesToBase64Url(bytes: Uint8Array): string {
  let binary = '';
  for (let i = 0; i < bytes.byteLength; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary)
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/, '');
}

/**
 * Converts a hex string directly into a base64url string
 */
export function hexToBase64Url(hex: string): string {
  return bytesToBase64Url(hexToBytes(hex));
}

/**
 * Generates W3C ClearKey JWK license payload
 */
export function createClearKeyLicense(kidHex: string, keyHex: string): Uint8Array {
  const kidB64Url = hexToBase64Url(kidHex);
  const keyB64Url = hexToBase64Url(keyHex);

  const jwk = {
    keys: [
      {
        kty: 'oct',
        k: keyB64Url,
        kid: kidB64Url,
      },
    ],
    type: 'temporary',
  };

  return new TextEncoder().encode(JSON.stringify(jwk));
}

/**
 * Configures HTML5 Video Element with ClearKey EME
 */
export async function setupClearKeyDrm(
  videoElement: HTMLVideoElement,
  kidHex: string,
  keyHex: string
): Promise<() => void> {
  if (!navigator.requestMediaKeySystemAccess) {
    throw new Error('Encrypted Media Extensions (EME) is not supported in this browser');
  }

  const cleanKid = kidHex.trim().replace(/-/g, '');
  const cleanKey = keyHex.trim().replace(/-/g, '');

  if (!cleanKid || !cleanKey) {
    throw new Error('Valid KID and KEY are required for ClearKey configuration');
  }

  const keySystemConfig: MediaKeySystemConfiguration[] = [
    {
      initDataTypes: ['cenc', 'keyids', 'webm'],
      videoCapabilities: [
        { contentType: 'video/mp4; codecs="avc1.42E01E"' },
        { contentType: 'video/mp4; codecs="avc1.4D401F"' },
        { contentType: 'video/mp4; codecs="avc1.640028"' },
      ],
      audioCapabilities: [
        { contentType: 'audio/mp4; codecs="mp4a.40.2"' },
      ],
    },
  ];

  try {
    const keySystemAccess = await navigator.requestMediaKeySystemAccess('org.w3.clearkey', keySystemConfig);
    const mediaKeys = await keySystemAccess.createMediaKeys();

    // Only setMediaKeys if not already set to this instance
    if ((videoElement as any).mediaKeys !== mediaKeys) {
      try {
        await videoElement.setMediaKeys(mediaKeys);
      } catch (smkErr: any) {
        // If another request is in progress or already set, log warning and continue
        console.warn('[ClearKey] setMediaKeys warning:', smkErr.message || smkErr);
      }
    }

    const onEncrypted = async (event: MediaEncryptedEvent) => {
      try {
        const session = mediaKeys.createSession();
        const license = createClearKeyLicense(cleanKid, cleanKey);

        session.addEventListener('message', async (messageEvent: MediaKeyMessageEvent) => {
          try {
            await session.update(license as unknown as BufferSource);
          } catch (updateErr) {
            console.warn('[ClearKey] Session update warning:', updateErr);
          }
        });

        if (event.initData) {
          await session.generateRequest(event.initDataType || 'cenc', event.initData);
        }
      } catch (err) {
        console.warn('[ClearKey] Error handling encrypted event:', err);
      }
    };

    videoElement.addEventListener('encrypted', onEncrypted as unknown as EventListener);

    return () => {
      videoElement.removeEventListener('encrypted', onEncrypted as unknown as EventListener);
      videoElement.setMediaKeys(null).catch(() => {});
    };
  } catch (err: any) {
    console.error('[ClearKey] Setup failed:', err);
    throw new Error(`ClearKey DRM setup failed: ${err.message || 'Key system unavailable'}`);
  }
}
