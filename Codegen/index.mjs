import { htmlTagNames } from "html-tag-names";
import { htmlVoidElements } from "html-void-elements";
import { htmlElementAttributes } from "html-element-attributes";
import * as kcpModule from "known-css-properties";

const json = {
    "tagNames": htmlTagNames,
    "voidElements": htmlVoidElements,
    "elementAttributes": htmlElementAttributes,
    "cssProperties": kcpModule.all
};

const string = JSON.stringify(json, undefined, 2);

console.log(string);