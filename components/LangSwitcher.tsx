"use client";

import type { Locale } from "../i18n/config";
import { COOKIE_NAME } from "../i18n/config";
import { usePathname, useRouter } from "next/navigation";

function setCookie(name: string, value: string) {
  document.cookie = `${name}=${value}; Path=/; Max-Age=${60 * 60 * 24 * 365}; SameSite=Lax`;
}

function getNextPath(pathname: string, nextLang: Locale) {
  const parts = pathname.split("/");
  // parts[0] = "" , parts[1] = "es|en"
  if (parts.length >= 2) parts[1] = nextLang;
  const next = parts.join("/");
  return next.startsWith("/") ? next : `/${next}`;
}

export default function LangSwitcher({
  lang,
  dict,
}: {
  lang: Locale;
  dict: any;
}) {
  const router = useRouter();
  const pathname = usePathname() || `/${lang}`;

  function switchTo(nextLang: Locale) {
    setCookie(COOKIE_NAME, nextLang);
    router.push(getNextPath(pathname, nextLang));
    router.refresh();
  }

  return (
    <label style={{ display: "flex", gap: 8, alignItems: "center" }}>
      <span>{dict.language.label}:</span>
      <select value={lang} onChange={(e) => switchTo(e.target.value as Locale)}>
        <option value="es">{dict.language.spanish}</option>
        <option value="en">{dict.language.english}</option>
      </select>
    </label>
  );
}