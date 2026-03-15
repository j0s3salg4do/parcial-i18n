export const BgColorHouses: Record<string, string> = {
  Gryffindor: "bg-[#740001]",
  Slytherin: "bg-[#1A472A]",
  Ravenclaw: "bg-[#0E1A40]",
  Hufflepuff: "bg-[#FFD800]",
  NoHouse: "bg-[#6B7280]",
};

export const BorderColorHouses: Record<string, string> = {
  Gryffindor: "border-[#740001]",
  Slytherin: "border-[#1A472A]",
  Ravenclaw: "border-[#0E1A40]",
  Hufflepuff: "border-[#FFD800]",
  NoHouse: "border-[#6B7280]",
};

export function getHouseBg(house?: string) {
  return BgColorHouses[house || ""] || BgColorHouses.NoHouse;
}

export function getHouseBorder(house?: string) {
  return BorderColorHouses[house || ""] || BorderColorHouses.NoHouse;
}