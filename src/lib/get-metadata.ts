// import fs from "fs";
// import path from "path";
// import fm from "front-matter";

export default function getMetadata(relativePath: string): Array<any> {
  // const files = fs.readdirSync(path.join(path.resolve(), relativePath));
  // const articles = files
  //   .map((file) => path.basename(file))
  //   .filter(
  //     (basename) =>
  //       path.extname(basename) === ".md" &&
  //       basename !== "index.md" &&
  //       basename[0] !== "_"
  //   );
  // let metadata = articles.map((article) => {
  //   const content = fs.readFileSync(
  //     path.join(path.resolve(), "src/routes/articles", article),
  //     { encoding: "utf-8" }
  //   );
  //   let attributes = fm(content).attributes;
  //   if (typeof attributes.title === "undefined") {
  //     attributes.title = path.basename(article, ".md");
  //   }
  //   return attributes;
  // });
  // return metadata;
  return [];
}
