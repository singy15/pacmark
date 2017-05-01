# pacmark
Packaged markdown converter.

## About

This converter converts the image files to base64 format and embeds it in the original markdown file.

## How to use

### Pack

Convert ordinary md file with some files to packaged md file.

```
ruby pacmark.rb pack foo.md
```

### Unpack

Convert packaged md file to ordinary md file.

```
ruby pacmark.rb unpack foo.md
```

### **Caution**

Original md file will be overwritten by process.
Make sure you backup your md file.


