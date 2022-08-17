# push2confluence

## What's this?

- Takes a properly annotated Markdown file
- Converts the contents into Confluence's storage format (XHTML)
- Replaces the corresponding page in Confluence

## Configuration

Create a file `~/.confluence` with:

```ruby
CONFLUENCE_SERVER = 'https://confluence.my.domain'
PERSONAL_ACCESS_TOKEN = 'my_personal_token' # Profile -> Settings -> Personal Access Tokens
SPACE_KEY = '~username'
```

## What does "properly annotated Markdown" mean?

- The Markdown file must have a YAML front matter section.
- The front matter must have a property `confluence-page-id`
- The property must refer to an existing page ID in Confluence.
- The page must exist in the Confluence space with key `SPACE_KEY`.

## How to get a valid page ID

- Find the relevant page on Confluence.
  - Create it first, if needed. This script doesn't do that for you!
- Go the the Page Information (in the `...` menu top-right)
- Extract the pageID parameter from the URL

## About the Markdown to XHTML conversion

- Markdown is converted to XHTML with Redcarpet, including support for:
  - tables
  - footnotes
  - fenced code blocks
- All wiki links are turned into normal text. These wouldn't work anyway.
- No other things are done. So file inclusions, images and other "special" things won't work.
- The final XHTML is prefixed with a hard-coded warning, stating that editing is of no use.

## Notes

- Works on Ruby 3.1.2. No other versions tried.
- Tests? Who needs tests? Just run the thing already!
- [Confluence REST API documentation](https://developer.atlassian.com/server/confluence/confluence-rest-api-examples)
