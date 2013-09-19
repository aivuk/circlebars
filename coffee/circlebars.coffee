chartHeight = 600
circleRadius = 20
circleDistance = 10
circleBorder = 4
paddingBottom = 60
metas = {}
eixos = {}
filterColumns = ["educacao", "saude"]

fcLabels = {}
fcLabels["educacao"] = "Educação"
fcLabels["saude"] = "Saúde"

eixosColor =
    normal: ["#34b74a", "#4b2bbf", "#ff7f00"]
    hover: ["#34b74a", "#4b2bbf", "#ff7f00"]
    stroke: ["#054f13", "#231459", "#8c4600"]

d3.csv "/data/metas.csv", (d) ->
    x_ticks = 0
    # Group the data
    d.forEach (r) ->
        if metas[r['objetivo']]?
            metas[r['objetivo']].push r
        else
            x_ticks += 1
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
    chartHeight = maxHeight*(2*circleRadius + circleDistance) + paddingBottom
    chartWidth = x_ticks*(2*circleRadius + circleDistance)

    # Create the SVG
    chart = d3.select("#circlebars")
                .append("svg:svg")
                    .attr("width", "#{chartWidth}px")
                    .attr("height", "#{chartHeight}px")

    groups = {}
    for f in filterColumns
        groups[f] = []

    x_tick = circleRadius + circleDistance
    for o, ms of metas
        do (ms) ->
            chart.append("svg:text")
                .text(o)
                .attr("x", x_tick)
                .attr("y", chartHeight - paddingBottom/10)
                .attr("text-anchor", "middle")
                .attr("font-size", "25px")
            x_tick += 2*circleRadius + circleDistance

            ms.forEach (m, i) ->
                for f in filterColumns
                    if m[f] == "TRUE"
                        groups[f].push m['id']
                chart.append("svg:circle")
                        .attr("transform", "translate(0, -#{paddingBottom})")
                        .attr("class", "circ")
                        .attr("cy", chartHeight - (i * (2*circleRadius + circleDistance)))
                        .attr("cx", (parseInt(o) - 1) * (2*circleRadius + circleDistance) + circleDistance + circleRadius)
                        .attr("r", circleRadius)
                        .attr("fill", (state) -> if m['estado'] == "concluída" then "red" else eixosColor['normal'][m['eixo'] - 1])
                        .attr("class", "circ")
                        .attr("id", "circ-#{ m['id']}")
                        .attr("title", m['texto'])
                        .on "mouseover", () ->
                                d3.select(this)
                                    .transition()
                                    .attr("fill-opacity", 0.4)
                                    .attr("stroke", "#333")
                                    .attr("stroke-width", "4")
                                d3.select("#metaInfo").text m['texto']
                        .on "mouseout", () ->
                                d3.select(this)
                                    .transition()
                                    .attr("fill", (state) -> if m['estado'] == "concluída" then "red" else eixosColor['normal'][m['eixo'] - 1])
                                    .attr("fill-opacity", 1)
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

