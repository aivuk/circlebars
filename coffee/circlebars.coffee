numbers = [[1, 2], [2], [4, 5, 6]]
chartHeight = 600
circleRadius = 20
circleDistance = 10
metas = {}
eixos = {}
filterColumns = ["educacao", "saude"]

fcLabels = {}
fcLabels["educacao"] = "Educação"
fcLabels["saude"] = "Saúde"

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
    chartHeight = maxHeight*(2*circleRadius + 1.5*circleDistance)

    # Create the SVG
    chart = d3.select("#circlebars")
                .style("height", parseInt(chartHeight) + "px")
                .append("svg:svg")
                    .attr("width", "100%")
                    .attr("height", "100%")

    groups = {}
    for f in filterColumns
        groups[f] = []

    for o, ms of metas
        do (ms) ->
            ms.forEach (m, i) ->
                for f in filterColumns
                    if m[f] == "TRUE"
                        groups[f].push m['id']
                console.log groups
                chart.append("svg:circle")
                        .attr("class", "circ")
                        .attr("cy", chartHeight - (i * (2*circleRadius + circleDistance)) - 2*circleRadius)
                        .attr("cx", (parseInt(o) - 1) * (2*circleRadius + circleDistance) + circleDistance + circleRadius)
                        .attr("r", circleRadius)
                        .attr("fill", (state) -> if m['estado'] == "concluída" then "red" else eixosColor[m['eixo'] - 1])
                        .attr("class", "circ")
                        .attr("id", "circ-#{ m['id']}")
                        .attr("title", m['texto'])
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


    $(".circ").tipsy({gravity: 'w', opacity: 0.9})
    filterFunc = (ftag_id, g) ->
        () ->
            enableFilter = not d3.select(this).classed("label-success")

            d3.selectAll(".filterTags")
                .classed("label-primary", true)
                .classed("label-success", false)

            d3.select("##{ ftag_id }")
                .classed("label-primary", () -> not enableFilter)
                .classed("label-success", () -> enableFilter)

            d3.selectAll(".filtered")
                .classed("filtered", false)

            for c in groups[g]
                d3.select("#circ-#{c}")
                    .classed("filtered", () -> enableFilter)

    filtersDiv = d3.select("#filters")
    for f in filterColumns
        ftag_id = "filter-#{f}"
        filtersDiv.append("div")
            .attr("id", ftag_id)
            .classed("filterTags label label-primary", true)
            .text(fcLabels[f])
            .on "click", filterFunc(ftag_id, f)

