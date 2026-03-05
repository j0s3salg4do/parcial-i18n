import type { Locale } from "@/i18n/config";
import { getDictionary } from "@/i18n/get-dictionary";

export default async function Profile({
  params,
}: {
  params: Promise<{ lang: Locale }>;
}) {
  const { lang } = await params;
  const dict = await getDictionary(lang);

  return (
    <div>
      <h1>{dict.profile.title}</h1>
      <p>{dict.profile.text}</p>
    </div>
  );
}