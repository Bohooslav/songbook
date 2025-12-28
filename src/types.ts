export type colorTheme =
  | "dark"
  | "light"
  | "black"
  | "gray"
  | "sepia"
  | "white";

type Line = {
  text?: string;
  chords?: string | string[];
  break?: true;
  bridge?: true;
  refrain?: true;
};

export type Song = {
  name: string;
  lines: Line[];
  transposition?: number;
};
