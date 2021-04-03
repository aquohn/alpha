.pragma library

var spacing = 10

function calculate_width(elem) {
    let children = elem.children
    let width = 0
    let maxheight = 0
    let maxwidth = 0
    for (let i = 0; i < children.length; i++) {
        width += children[i].width

        if (children[i].height > maxheight) {
            maxheight = children[i].height
        }

        if (children[i].width > maxwidth) {
            maxwidth = children[i].width
        }
    }

    return Math.max(Math.sqrt(width * maxheight), (maxwidth + 2 * spacing))
}
