type Props = {
  rights: string;
  dev: string;
};

export default function Footer({ rights, dev }: Props) {
  return (
    <footer className="bg-[#BBCCBB] px-4 py-3 text-xs font-semibold text-black">
      <div className="mx-auto flex max-w-6xl items-center justify-between">
        <span>{rights}</span>
        <span>{dev}</span>
      </div>
    </footer>
  );
}