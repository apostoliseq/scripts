# read
Wait for user input and save it to variable

# -z "$file_path"
Check if user entered nothing (empty input)

# -f "$file_path"
Check if file actually exists

# filename=$(basename "$file_path")
## basename "$file_path"
Strip the path, keep just the file name
## ${filename%.*}
Remove the last dot (.) and everything after it
### ${var%pattern}
Parameter Expansion
Take the value of `var`
Look for the pattern `.*`
Remove it, but only starting from the end
`%` = remove smallest matching part from the end
`%%` = remove biggest matching part from the end
Example:
var="hello.world.txt"
${var%.*} returns hello.world
${var%%.*} returns hello

# grep -v "^$" "$file_path" > "$temp_file"
Write only the non-empty lines
`^` = start of line
`$` = end of line
`^$` = empty line (nothing between start and end)

# nl -s') ' -w1 < <(tac "$temp_file") > "$output_file"
## tac "$temp_file"
Read the file backwards (last line first)
## < <(tac "$temp_file")
Passe the reversed content directly to `nl`
### <(...)
Process Substitution
It tricks a program (like nl) into thinking a running command (tac "$temp_file") is just a regular input file
## nl -s') ' -w1
### nl (number lines)
Read the input and add numbers to the start of each line
### -s') '
After the number, put a `)` and a space
### -w1
Use at least 1 digit for the numbers (1, 2, 3... no leading zeros)
`-w1`: Numbers are like 1, 2, 3 — no leading zeros
`-w2`: Numbers are like 01, 02, 03 — with leading zeros

# truncate -s -1 "$output_file"
Delete 1 byte (removes the final newline)
`-s`: set size
`-1`: decrease size by 1 byte (negative numbers shrink the file)
