import type { Locale } from "../../i18n/config";
import { getDictionary } from "../../i18n/get-dictionary";
import Link from "next/link";
import LangSwitcher from "../../components/LangSwitcher";

export default async function LangLayout({
  params,
  children,
}: {
  params: Promise<{ lang: Locale }>;
  children: React.ReactNode;
}) {
  const { lang } = await params;
  const dict = await getDictionary(lang);

  return (
    <>
      <header style={{ padding: 16, borderBottom: "1px solid #ddd" }}>
        <nav style={{ display: "flex", gap: 12, alignItems: "center" }}>
          <Link href={`/${lang}`}>{dict.nav.home}</Link>
          <Link href={`/${lang}/profile`}>{dict.nav.profile}</Link>
          <div style={{ marginLeft: "auto" }}>
            <LangSwitcher lang={lang} dict={dict} />
          </div>
        </nav>
      </header>
      <main style={{ padding: 24 }}>{children}</main>
    </>
  );
}