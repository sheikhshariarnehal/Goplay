import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { AuthProvider } from "../providers/auth-provider";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "GoPlay TV | Admin Dashboard",
  description: "Administrative panel for managing categories, channels, events, and announcements.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
      suppressHydrationWarning
    >
      <head>
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function() {
                if (typeof window !== 'undefined' && window.XMLHttpRequest) {
                  try {
                    var desc = Object.getOwnPropertyDescriptor(XMLHttpRequest.prototype, 'responseText');
                    if (desc && desc.get) {
                      var originalGet = desc.get;
                      Object.defineProperty(XMLHttpRequest.prototype, 'responseText', {
                        get: function() {
                          if (this.responseType && this.responseType !== '' && this.responseType !== 'text') {
                            return '';
                          }
                          try {
                            return originalGet.call(this);
                          } catch (e) {
                            return '';
                          }
                        },
                        configurable: true,
                        enumerable: true
                      });
                    }
                  } catch (err) {}
                }
              })();
            `,
          }}
        />
      </head>
      <body className="min-h-full flex flex-col">
        <AuthProvider>
          {children}
        </AuthProvider>
      </body>
    </html>
  );
}
