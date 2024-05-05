import { htmlTagNames } from "html-tag-names";
import { htmlVoidElements } from "html-void-elements";
import { htmlElementAttributes } from "html-element-attributes";

const json = {
    "tagNames": htmlTagNames,
    "voidElements": htmlVoidElements,
    "elementAttributes": htmlElementAttributes
};

const string = JSON.stringify(json, undefined, 2);

console.log(string);