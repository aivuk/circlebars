numbers = [[1, 2], [2], [4, 5, 6]]
chartHeight = 600
circleRadius = 20
circleDistance = 5
metas = {}

d3.csv "/data/metas.csv", (d) ->
    d.forEach (r) ->
        if metas[r['objetivo']]?
            metas[r['objetivo']].push r
        else
            metas[r['objetivo']] = [r]

    maxHeight = Math.max (ms.length for o, ms of metas)...
    chartHeight = maxHeight*(2*circleRadius + 2*circleDistance)

    chart = d3.select("#circlebars")
                .style("height", parseInt(chartHeight) + "px")
                .append("svg:svg")
                    .attr("width", "100%")
                    .attr("height", "100%")

    for o, ms of metas
        console.log o
        do (ms) ->
            ms.forEach (m, i) ->
                chart.append("svg:circle")
                        .attr("class", "circ")
                        .attr("cy", chartHeight - (i * (2*circleRadius + circleDistance)) - 2*circleRadius)
                        .attr("cx", (parseInt(o) - 1) * (2*circleRadius + circleDistance) + 2*circleRadius)
                        .attr("r", circleRadius)
                        .attr("fill", (state) -> if m['estado'] == "concluída" then "green" else "blue")
                        .on "mouseover", () ->
                                d3.select(this)
                                    .transition()
                                    .attr("fill", "red")
                                d3.select("#metaInfo").text m['texto']
                        .on "mouseout", () ->
                                d3.select(this)
                                    .transition()
                                    .attr("fill", (state) -> if m['estado'] == "concluída" then "green" else "blue")
                                d3.select("#metaInfo").text ''


