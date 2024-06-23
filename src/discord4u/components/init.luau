local stdio = require("@lune/stdio")

return {
    printTerminal = function(str)
        stdio.write(stdio.style("bold")..stdio.color("purple").."Discord4u: ")
        stdio.write(stdio.style("reset")..stdio.color("reset"))
        print(str)
    end
}