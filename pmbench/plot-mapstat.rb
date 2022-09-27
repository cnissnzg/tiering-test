#!/usr/bin/env ruby

LKP_SRC ||= ENV['LKP_SRC'] || File.dirname(__dir__)
require 'gnuplot'
require "#{LKP_SRC}/lib/statistics"

def parse()
  ts_base = 0
  ts = 0
  dcs = []
  pcs = []
  $stdin.each_line do |line|
    case line
    when /^time: (\d+\.\d+)/
      ts=$1.to_f
      if ts_base == 0
        ts_base = ts
      end
    when /^dc: (.*)/
      dcs = $1.split().map { |s| s.to_i }
    when /^pc: (.*)/
      pcs = $1.split().map { |s| s.to_i }
      yield ts - ts_base, dcs, pcs
    end
  end
end

def plot(ts, dcps)
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      len = dcps.length
      xs = (0..len).map { |x| x * 100.0 / len}
      plot.data << Gnuplot::DataSet.new([xs, dcps]) do |ds|
        ds.with = 'boxes'
        ds.notitle
      end
      plot.data << Gnuplot::DataSet.new([[0, 40, 40, 60, 60, 100],
                                         [0, 0, 100, 100, 0, 0]]) do |ds|
        ds.with = 'line'
        ds.linewidth = 3
        ds.notitle
      end
      tsi = ts.to_i
      plot.yrange "[0:100]"
      plot.xrange "[0:100]"
      plot.notitle
      plot.title format("time: %4d", tsi)
      #plot.terminal 'png noenhanced size 560,336'
      plot.terminal 'png noenhanced size 800,480'
      plot.output format("%04d.png", tsi)
    end
  end
end

def main()
  parse do |ts, dcs, pcs|
    dcps = dcs.zip(pcs).map do |dc, pc|
      tc = dc + pc
      if tc == 0
        0
      else
        dc * 100.0 / tc
      end
    end
    #puts "#{ts}: #{dcps}"
    plot ts, dcps
  end
end

main
