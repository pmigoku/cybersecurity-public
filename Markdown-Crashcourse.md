# Markdown Crash Course

Markdown is a lightweight markup language with plain-text formatting syntax. It's designed to be easy to write, easy to read, and to be converted into HTML. This file itself is written in Markdown.

## Text Formatting

You can easily format text to be **bold**, *italic*, or ~~struck-through~~.

**Syntax:**
```markdown
*This text will be italic.*
_This will also be italic._

**This text will be bold.**
__This will also be bold.__

***This text is both bold and italic.***

~~This text will be struck-through.~~
```

**Result:**

*This text will be italic.*
_This will also be italic._

**This text will be bold.**
__This will also be bold.__

***This text is both bold and italic.***

~~This text will be struck-through.~~

## Headings

Headings are created by prefixing a line with a hash symbol (`#`). The number of hashes determines the heading level.

**Syntax:**
```markdown
# Heading 1 (Largest)
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6 (Smallest)
```

## Lists

### Unordered Lists
You can create bulleted lists using asterisks (`*`), hyphens (`-`), or plus signs (`+`).

**Syntax:**
```markdown
* Item 1
* Item 2
  * Nested Item 2a
  * Nested Item 2b
- Item 3
+ Item 4
```

**Result:**
* Item 1
* Item 2
  * Nested Item 2a
  * Nested Item 2b
- Item 3
+ Item 4

### Ordered Lists
Create numbered lists using numbers followed by a period. The actual numbers you use don't matter; Markdown will render them sequentially.

**Syntax:**
```markdown
1. First item
2. Second item
3. Third item
1. Fourth item (Markdown fixes the numbering)
```

**Result:**
1. First item
2. Second item
3. Third item
1. Fourth item (Markdown fixes the numbering)


## Links and Images

### Links
Create a hyperlink by wrapping the link text in brackets `[]` and the URL in parentheses `()`.

**Syntax:**
```markdown
[Visit Google](https://www.google.com)
```
**Result:**
[Visit Google](https://www.google.com)

### Images
Image syntax is similar to links but with a preceding exclamation mark `!`.

**Syntax:**
```markdown
![A cute robot](https://www.google.com/images/errors/robot.png)
```
**Result:**
![A cute robot](https://www.google.com/images/errors/robot.png)


## Code

### Inline Code
Wrap code within a sentence using single backticks (`` ` ``).

**Syntax:**
```markdown
To see your files, use the `ls -la` command.
```
**Result:**
To see your files, use the `ls -la` command.

### Fenced Code Blocks
For multi-line code blocks, use triple backticks (```` ``` ````). You can also specify the language for syntax highlighting by placing the name of the language after the first set of (```` ```bash ````)

**Syntax:**
```python
import requests

def get_page(url):
  response = requests.get(url)
  return response.text
```


## Calling out important info
```
> [!NOTE]  
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]  
> Crucial information necessary for users to succeed.

> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.
```

Here is how they display:
> [!NOTE]  
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]  
> Crucial information necessary for users to succeed.

> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.