numbers = [[1, 2], [2], [4, 5, 6]]
chartHeight = 600
circleRadius = 20
circleDistance = 10
metas = {}
eixos = {}

eixosColor = ["#34b746", "#4b2bbf", "#ff7f00"]

d3.csv "/data/metas.csv", (d) ->
    # Group the data
    d.forEach (r) ->
        if metas[r['objetivo']]?
            metas[r['objetivo']].push r
        else
            metas[r['objetivo']] = [r]

        if eixos[r['eixo']]?
            if r['objetivo'] not in eixos[r['eixo']]
                eixos[r['eixo']].push r['objetivo']
        else
            eixos[r['eixo']] = [r['objetivo']]

    # Calculate the number of elements in each axe group
    eixosSize = []
    for i of eixos
        do (i) ->
            eixosSize.push eixos[i].length

    maxHeight = Math.max (ms.length for o, ms of metas)...
    chartHeight = maxHeight*(2*circleRadius + 2*circleDistance)

    # Create the SVG
    chart = d3.select("#circlebars")
                .style("height", parseInt(chartHeight) + "px")
                .append("svg:svg")
                    .attr("width", "100%")
                    .attr("height", "100%")

    # Draw the rectangles
    #i = 0
    #lastWidth = 0
    #while i < eixosSize.length
    #    chart.append("svg:rect")
    #        .attr("x", lastWidth)
    #        .attr("y", 0)
    #        .attr("width", eixosSize[i]*(2*circleRadius + circleDistance) + circleDistance)
    #        .attr("height", chartHeight)
    #        .attr("fill", eixosColor[i])
    #    lastWidth += eixosSize[i]*(2*circleRadius + circleDistance) + circleDistance
    #    i += 1

    for o, ms of metas
        do (ms) ->
            ms.forEach (m, i) ->
                chart.append("svg:circle")
                        .attr("class", "circ")
                        .attr("cy", chartHeight - (i * (2*circleRadius + circleDistance)) - 2*circleRadius)
                        .attr("cx", (parseInt(o) - 1) * (2*circleRadius + circleDistance) + circleDistance + circleRadius)
                        .attr("r", circleRadius)
                        .attr("fill", (state) -> if m['estado'] == "concluída" then "red" else eixosColor[m['eixo'] - 1])
                        .on "mouseover", () ->
                                d3.select(this)
                                    .transition()
                                    .attr("fill", "white")
                                    .attr("stroke", "#444")
                                    .attr("stroke-width", "4")
                                d3.select("#metaInfo").text m['texto']
                        .on "mouseout", () ->
                                d3.select(this)
                                    .transition()
                                    .attr("fill", (state) -> if m['estado'] == "concluída" then "red" else eixosColor[m['eixo'] - 1])
                                    .attr("stroke-width", "0")
                                d3.select("#metaInfo").text ''


