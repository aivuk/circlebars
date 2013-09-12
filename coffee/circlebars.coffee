numbers = [[1, 2], [2], [4, 5, 6]]
chartHeight = 650

metas = {}

d3.csv "/data/metas.csv", (d) ->
    d.forEach (r) ->
        if metas[r['objetivo']]?
            metas[r['objetivo']].push r
        else
            metas[r['objetivo']] = [r]

    for o, ms of metas
        do (ms) ->
            ms.forEach (m, i) ->
                chart.append("svg:circle")
                            .attr("class", "circ")
                            .attr("cy", chartHeight - (i * (40 + 5)) - 40)
                            .attr("cx", parseInt(o) * (40 + 5) + 40)
                            .attr("r", 20)
                            .attr("fill", "blue")
                            .on "mouseover", () ->
                                    d3.select(this)
                                        .transition()
                                        .attr("fill", "red")
                            .on "mouseout", () ->
                                    d3.select(this)
                                        .transition()
                                        .attr("fill", "blue")

chart = d3.select("#circlebars")
            .append("svg:svg")
                .attr("width", "100%")
                .attr("height", "100%")

circles = d3.selectAll(".circ")

