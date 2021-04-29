import { metadata } from "../_articles";

export function get() {
  return {
    body: metadata,
  };
}
