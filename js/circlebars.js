// Generated by CoffeeScript 1.6.3
(function() {
  var chartHeight, circleBorder, circleDistance, circleRadius, filterColumns, groupCol, groups, groupsColor, lineCol, lines, linkCol, paddingBottom,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  chartHeight = 600;

  circleRadius = 20;

  circleDistance = 10;

  circleBorder = 4;

  paddingBottom = 60;

  groups = {};

  lines = {};

  filterColumns = ["Educação", "Saúde"];

  lineCol = "objetivo";

  groupCol = "eixo";

  linkCol = "link_blog";

  groupsColor = {
    normal: ["#34b74a", "#4b2bbf", "#ff7f00"],
    hover: ["#34b74a", "#4b2bbf", "#ff7f00"],
    stroke: ["#054f13", "#231459", "#8c4600"]
  };

  d3.csv("/data/metas.csv", function(d) {
    var chart, chartWidth, f, filterFunc, filteredGroups, filtersDiv, ftag_id, groupsSize, i, maxHeight, ms, o, x_tick, x_ticks, _fn, _fn1, _i, _j, _len, _len1, _results;
    x_ticks = 0;
    d.forEach(function(r) {
      var _ref;
      if (lines[r[lineCol]] != null) {
        lines[r[lineCol]].push(r);
      } else {
        x_ticks += 1;
        lines[r[lineCol]] = [r];
      }
      if (groups[r[groupCol]] != null) {
        if (_ref = r[lineCol], __indexOf.call(groups[r[groupCol]], _ref) < 0) {
          return groups[r[groupCol]].push(r[lineCol]);
        }
      } else {
        return groups[r[groupCol]] = [r[lineCol]];
      }
    });
    groupsSize = [];
    _fn = function(i) {
      return groupsSize.push(groups[i].length);
    };
    for (i in groups) {
      _fn(i);
    }
    maxHeight = Math.max.apply(Math, (function() {
      var _results;
      _results = [];
      for (o in lines) {
        ms = lines[o];
        _results.push(ms.length);
      }
      return _results;
    })());
    chartHeight = maxHeight * (2 * circleRadius + circleDistance) + paddingBottom;
    chartWidth = x_ticks * (2 * circleRadius + circleDistance);
    chart = d3.select("#circlebars").append("svg:svg").attr("width", "" + chartWidth + "px").attr("height", "" + chartHeight + "px");
    filteredGroups = {};
    for (_i = 0, _len = filterColumns.length; _i < _len; _i++) {
      f = filterColumns[_i];
      filteredGroups[f] = [];
    }
    x_tick = circleRadius + circleDistance;
    _fn1 = function(ms) {
      chart.append("svg:text").text(o).attr("x", x_tick).attr("y", chartHeight - paddingBottom / 10).attr("text-anchor", "middle").attr("font-size", "25px");
      x_tick += 2 * circleRadius + circleDistance;
      return ms.forEach(function(m, i) {
        var _j, _len1;
        for (_j = 0, _len1 = filterColumns.length; _j < _len1; _j++) {
          f = filterColumns[_j];
          if (m[f] === "TRUE") {
            filteredGroups[f].push(m['id']);
          }
        }
        return chart.append("svg:a").attr("xlink:href", m[linkCol]).append("svg:circle").attr("transform", "translate(0, -" + paddingBottom + ")").attr("class", "circ").attr("cy", chartHeight - (i * (2 * circleRadius + circleDistance))).attr("cx", (parseInt(o) - 1) * (2 * circleRadius + circleDistance) + circleDistance + circleRadius).attr("r", circleRadius).attr("fill", function(state) {
          if (m['estado'] === "concluída") {
            return "red";
          } else {
            return groupsColor['normal'][m[groupCol] - 1];
          }
        }).attr("class", "circ").attr("id", "circ-" + m['id']).attr("title", m['texto']).on("mouseover", function() {
          d3.select(this).transition().attr("fill-opacity", 0.4).attr("stroke", "#333").attr("stroke-width", "4");
          return d3.select("#metaInfo").text(m['texto']);
        }).on("mouseout", function() {
          d3.select(this).transition().attr("fill", function(state) {
            if (m['estado'] === "concluída") {
              return "red";
            } else {
              return groupsColor['normal'][m[groupCol] - 1];
            }
          }).attr("fill-opacity", 1).attr("stroke-width", "0");
          return d3.select("#metaInfo").text('');
        });
      });
    };
    for (o in lines) {
      ms = lines[o];
      _fn1(ms);
    }
    $(".circ").tipsy({
      gravity: 'w',
      opacity: 0.9
    });
    filterFunc = function(ftag_id, g) {
      return function() {
        var c, enableFilter, _j, _len1, _ref, _results;
        enableFilter = !d3.select(this).classed("label-selected");
        d3.selectAll(".label-selected").classed("label-selected", function() {
          return false;
        });
        d3.select("#" + ftag_id).classed("label-selected", function() {
          return enableFilter;
        });
        d3.selectAll(".filtered").classed("filtered", false);
        _ref = filteredGroups[g];
        _results = [];
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          c = _ref[_j];
          _results.push(d3.select("#circ-" + c).classed("filtered", function() {
            return enableFilter;
          }));
        }
        return _results;
      };
    };
    filtersDiv = d3.select("#filters");
    _results = [];
    for (_j = 0, _len1 = filterColumns.length; _j < _len1; _j++) {
      f = filterColumns[_j];
      ftag_id = "filter-" + f;
      _results.push(filtersDiv.append("div").attr("id", ftag_id).classed("filterTags label", true).text(f).on("click", filterFunc(ftag_id, f)));
    }
    return _results;
  });

}).call(this);
