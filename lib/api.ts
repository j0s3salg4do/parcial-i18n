export type Character = {
  id: string;
  name: string;
  image: string;
  house: string;
  gender: string;
  wizard: boolean;
  ancestry: string;
  species: string;
  actor: string;
  wand: {
    wood: string;
    core: string;
    length: number | null;
  };
};

const BASE_URL = "https://hp-api.onrender.com/api";

export async function getCharacters(): Promise<Character[]> {
  const res = await fetch(`${BASE_URL}/characters`, {
    next: { revalidate: 3600 },
  });

  if (!res.ok) {
    throw new Error("Error obteniendo personajes");
  }

  return res.json();
}

export async function getFirst12Characters(): Promise<Character[]> {
  const characters = await getCharacters();
  return characters.slice(0, 12);
}

export async function getCharacterById(id: string): Promise<Character | null> {
  const res = await fetch(`${BASE_URL}/character/${id}`, {
    next: { revalidate: 3600 },
  });

  if (!res.ok) {
    throw new Error("Error obteniendo personaje");
  }

  const data = await res.json();
  return data?.[0] || null;
}