#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 求职者: 郑伟 zw963@163.com
# 问题选择: TRAINS
# 语言: Ruby 2.0

require 'minitest/autorun'
require 'minitest/pride'
require_relative "train_route"


# ============================== 单元测试 ==============================

# TrainGraph
class TrainGraphInstance
  include TrainGraph
end

describe TrainGraphInstance do
  subject { TrainGraphInstance.new }

  describe '#train_graphs_hash' do
    it 'should return expected.' do
      def subject.graphs
        %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7)
      end
      expected = {"AB"=>"5", "BC"=>"4", "CD"=>"8", "DC"=>"8", "DE"=>"6", "AD"=>"5", "CE"=>"2", "EB"=>"3", "AE"=>"7"}
      subject.train_graphs_hash.must_equal expected, '.'
    end
  end

  describe '#train_graph_routes_hash' do
    it 'should return expected.' do
      def subject.train_graphs_hash
        {"AB"=>"5", "BC"=>"4", "CD"=>"8", "DC"=>"8", "DE"=>"6", "AD"=>"5", "CE"=>"2", "EB"=>"3", "AE"=>"7"}
      end
      expected = {"A"=>["AB", "AD", "AE"], "B"=>["BC"], "C"=>["CD", "CE"], "D"=>["DC", "DE"], "E"=>["EB"]}
      subject.train_graph_routes_hash.must_equal expected, '.'
    end
  end

  describe '#train_station_count' do
    it 'should return expected' do
      def subject.graphs
        %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7)
      end
      expected = 5
      subject.train_station_count.must_equal expected, '.'
    end
  end
end

# TrainNoRepeatRoute
class TrainNoRepeatRouteInstance
  include TrainNoRepeatRoute
end

describe TrainNoRepeatRouteInstance do
  subject { TrainNoRepeatRouteInstance.new }

  describe '#route_path' do
    it 'should return expected' do
      def subject.route
        "ABC"
      end
      expected = ["AB", "BC"]
      subject.route_path.must_equal expected, '.'
    end
  end

  describe '#route_distance' do
    it 'should return expected' do
      def subject.route_exist?
        false
      end
      expected = "NO SUCH ROUTE"
      subject.route_distance.must_equal expected, '.'
    end

    it 'should return 9' do
      def subject.route_exist?
        true
      end
      def subject.route_path
        ["AB", "BC"]
      end
      def subject.train_graphs_hash
        {"AB"=>"5", "BC"=>"4", "CD"=>"8", "DC"=>"8", "DE"=>"6", "AD"=>"5", "CE"=>"2", "EB"=>"3", "AE"=>"7"}
      end
      expected = 9
      subject.route_distance.must_equal expected, '.'
    end
  end

  describe '#route_exist?' do
    it 'should return true' do
      def subject.route_path
        ["AB", "BC"]
      end
      def subject.train_graphs_hash
        {"AB"=>"5", "BC"=>"4", "CD"=>"8", "DC"=>"8", "DE"=>"6", "AD"=>"5", "CE"=>"2", "EB"=>"3", "AE"=>"7"}
      end
      subject.route_exist?.must_equal true, '.'
    end

    it 'should return false' do
      def subject.route_path
        ["AC"]
      end
      def subject.train_graphs_hash
        {"AB"=>"5", "BC"=>"4", "CD"=>"8", "DC"=>"8", "DE"=>"6", "AD"=>"5", "CE"=>"2", "EB"=>"3", "AE"=>"7"}
      end
      subject.route_exist?.must_equal false, '.'
    end
  end

end

class TrainRepeatRouteInstance
  include TrainRepeatRoute
end

# describe TrainRepeatRouteInstance do
#   before do
#     @subject = TrainRepeatRouteInstance.new
#     @subject.graphs = %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7)
#   end

#   describe '#next_station_string_array' do
#     it 'should return expected' do
#       @subject.route = "A"
#       expected = ["AB", "AD", "AE"]
#       @subject.next_station_string_array.must_equal expected, '.'
#     end
#   end

#   # describe '#prase' do
#   #   it 'should return expected' do
#   #     @subject.route = "A"
#   #     expected = true
#   #     @subject.prase.must_equal expected, '.'
#   #   end
#   # end
# end
