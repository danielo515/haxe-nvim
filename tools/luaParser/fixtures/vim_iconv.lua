-- The result is a String, which is the text {str} converted from
-- encoding {from} to encoding {to}. When the conversion fails `nil` is
-- returned.  When some characters could not be converted they
-- are replaced with "?".
-- The encoding names are whatever the iconv() library function
-- can accept, see ":Man 3 iconv".
--
-- Parameters: ~
--   • {str}   (string) Text to convert
--   • {from}  (string) Encoding of {str}
--   • {to}    (string) Target encoding
--
-- Returns: ~
--     Converted string if conversion succeeds, `nil` otherwise.
--- @param str string
--- @param from number
--- @param to number
--- @param opts? table<string, any>
function vim.iconv(str, from, to, opts) end
