#!/usr/bin/env ruby

#LKP_SRC ||= ENV['LKP_SRC'] || File.dirname(__dir__)
LKP_SRC ||= "/home/yifeng/git/lkp-tests/"
require "#{LKP_SRC}/lib/statistics"
require "#{LKP_SRC}/lib/plot"

def parse()
  ts_base = 0
  tsp = 0
  ts = 0
  intvl = 1
  dcs = []
  pcs = []
  $stdin.each_line do |line|
    case line
    when /^time: (\d+\.\d+)/
      tsp = ts
      ts=$1.to_f
      if ts_base == 0
        ts_base = ts
      end
      intvl = ts - tsp
    when /^dc: (.*)/
      dcs = $1.split().map { |s| s.to_f / intvl }
    when /^pc: (.*)/
      pcs = $1.split().map { |s| s.to_f / intvl }
      yield ts - ts_base, dcs, pcs
    end
  end
end

XSTAT = "x"
DSTAT = "demote pg/s"
PSTAT = "promote pg/s"
PDSTAT = "promote - demote pg/s"

def main()
  tapcs = []
  vmax = 0
  vmin = 0
  tarr = []
  parse do |ts, dcs, pcs|
    pdcs = pcs.zip(dcs).map { |pc, dc| pc - dc }
    len = pdcs.length
    xs = (0..len).map { |x| x * 100.0 / len}

    matrix = {
      XSTAT => xs,
      DSTAT => dcs,
      PSTAT => pcs,
      PDSTAT => pdcs
    }
    vmax = [vmax, pdcs.max, pcs.max].max
    vmin = [vmin, pdcs.min, pcs.min].min
    tarr.append([ts, matrix])
  end
  plotter = MMatrixPlotter.new
  plotter.set_y_range([vmin, vmax])
    .set_x_range([0, 100])
    .set_x_stat_key(XSTAT)
    .set_xtics(true)
    .set_lines ([
                     ["0"]
                   ])
  tarr.each do |ts, matrix|
    lines = [PDSTAT, PSTAT].map do |stat|
      [matrix, stat, stat]
    end
    tsi = ts.to_i
    plotter.set_title(format("time: %4d", tsi))
      .set_output_file_name(format("%04d.png", tsi))
      .set_lines(lines)
      .plot
  end
end

main
