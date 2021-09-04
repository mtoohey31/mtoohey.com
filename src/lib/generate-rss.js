import fs from "fs";
import path from "path";
import jstoxml from "jstoxml";
const { toXML } = jstoxml;

const articles = JSON.parse(fs.readFileSync(path.join(path.resolve().toString(), "static/article-index.json"), 'utf8'));

const xmlOptions = {
  header: true,
  indent: " "
}

fs.writeFileSync(
  path.join(path.resolve().toString(), "static/rss.xml"),
  toXML({
    _name: "rss",
    _attrs: {
      version: "2.0",
      "xmlns:atom": "http://www.w3.org/2005/Atom"
    },
    _content: {
      channel: [
        {
          title: "Matthew Toohey"
        },
        {
          description: "Articles by Matthew Toohey."
        },
        {
          link: "https://mtoohey.com"
        },
        {
          _name: "atom:link", 
          _attrs: {
            href: "https://mtoohey.com/rss.xml",
            rel: "self",
            type: "application/rss+xml"
          }
        },
        {
          lastBuildDate: () => new Date().toUTCString(),
        },
        {
          pubDate: () => new Date().toUTCString(),
        },
        {
          language: "en"
        }
      ].concat(articles.map(article => {
        return {
          item: {
            title: article.title,
            link: `https://mtoohey.com/articles/${article.route}`,
            guid: `https://mtoohey.com/articles/${article.route}`,
            description: article.description,
            pubDate: new Date(article.posted).toUTCString()
          }
        }
      }))
    }
  }, xmlOptions)
);
