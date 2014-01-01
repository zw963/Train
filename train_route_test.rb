#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 求职者: 郑伟 zw963@163.com
# 问题选择: TRAINS
# 语言: Ruby 2.0.0-p353

require 'minitest/autorun'
require 'minitest/pride'

require_relative "train_route"

# ============================== 单元测试 ==============================
class TrainGraphSubject
  include TrainGraph
end

describe TrainGraphSubject do
  subject { TrainGraphSubject.new }

  describe "#graphs_hash" do
    it "应该使用 train graphs 生成一个 `哈希表'." do
      def subject.graphs
        %w{AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7}
      end
      expected = {
        "AB" => "5", "BC" => "4", "CD" => "8",
        "DC" => "8", "DE" => "6", "AD" => "5",
        "CE" => "2", "EB" => "3", "AE" => "7"
      }
      subject.graphs_hash.must_equal expected
    end
  end

  describe "#routes_hash" do
    it "应该使用 `graphs hash' 生成一个 `路由表'." do
      def subject.graphs_hash
        {
          "AB"=>"5", "BC"=>"4", "CD"=>"8",
          "DC"=>"8", "DE"=>"6", "AD"=>"5",
          "CE"=>"2", "EB"=>"3", "AE"=>"7"
        }
      end
      expected = {
        "A"=>["AB", "AD", "AE"],
        "B"=>["BC"],
        "C"=>["CD", "CE"],
        "D"=>["DC", "DE"],
        "E"=>["EB"]
      }
      subject.routes_hash.must_equal expected
    end
  end

  describe "#station_count" do
    it "应该根据 `路由表' 计算 `站点数量'." do
      def subject.routes_hash
        {
          "A"=>["AB", "AD", "AE"],
          "B"=>["BC"],
          "C"=>["CD", "CE"],
          "D"=>["DC", "DE"],
          "E"=>["EB"]
        }
      end
      expected = 5
      subject.station_count.must_equal expected
    end
  end
end

class String
  include TrainRouteStringExtension
end

TRAIN_GRAPHS_HASH = {
  "AB"=>"5", "BC"=>"4", "CD"=>"8",
  "DC"=>"8", "DE"=>"6", "AD"=>"5",
  "CE"=>"2", "EB"=>"3", "AE"=>"7"
}

describe TrainRouteStringExtension do
  subject { "ABC" }

  describe "#train_route_path" do
    it "应该返回 route 展开后的路径数组." do
      subject.train_route_path.must_equal ["AB", "BC"]
    end
  end

  describe "#train_route_exist?" do
    describe "当 route_path 存在时" do
      it "应该返回 true." do
        def subject.train_route_path
          ["AB", "BC", "CD"]
        end
        subject.train_route_exist?.must_equal true
      end
    end

    describe "当 route_path 不存在时" do
      it "应该返回 false." do
        def subject.train_route_path
          ["AC"]
        end
        subject.train_route_exist?.must_equal false
      end
    end
  end

  describe "#train_route_distance" do
    describe "当 train_route_exist? 为真时" do
      it "应该返回 `NO SUCH ROUTE' 消息." do
        def subject.train_route_exist?
          false
        end
        subject.train_route_distance.must_equal 'NO SUCH ROUTE', '.'
      end
    end

    describe "当 train_route_exist? 为假时" do
      it "应该计算 train route 的距离." do
        def subject.route_exist?
          true
        end
        def subject.route_path
          [ "AB", "BC" ]
        end
        subject.train_route_distance.must_equal 9
      end
    end
  end
end

class TrainRouteSubject
  include TrainRoute
end

describe TrainRouteSubject do
  subject { TrainRouteSubject.new }

  describe "#route_array" do
    describe "当 @route_array 非空时" do
      it "应该返回 Array[*@route_array]." do
        subject.instance_variable_set(:@route_array, ["DEF", "DFE"])
        def subject.route
          "AC"
        end
        subject.route_array.must_equal ["DEF", "DFE"], '.'
      end
    end

    describe "当 @route_array 为空时" do
      it "应该返回 Array[*route[0]]" do
        subject.instance_variable_set(:@route_array, nil)
        def subject.route
          "AC"
        end
        subject.route_array.must_equal ["A"]
      end
    end
  end

  # describe "#concatenated_station_array" do
  #   it "应该将路由 concat 到下一级站点的集合." do
  #     def subject.routes_hash
  #       {
  #         "A"=>["AB", "AD", "AE"],
  #         "B"=>["BC"],
  #         "C"=>["CD", "CE"],
  #         "D"=>["DC", "DE"],
  #         "E"=>["EB"]
  #       }
  #     end
  #     subject.concatenated_station_array("CD").must_equal ["CDC", "CDE"]
  #   end
  # end

  describe "#concat_station_to_route_array" do
    it "应该将当前站点 concat 进入下一级站点的数组" do
      def subject.route_array
        ["CD"]
      end
      def subject.routes_hash
        {
          "A"=>["AB", "AD", "AE"],
          "B"=>["BC"],
          "C"=>["CD", "CE"],
          "D"=>["DC", "DE"],
          "E"=>["EB"]
        }
      end
      subject.concat_station_to_route_array.must_equal ["CDC", "CDE"]
    end
  end

  # describe "#traversal" do
  #   it "应该调用 self.initialize_route_array=(concat_station_to_route_array)" do
  #     def subject.concat_station_to_route_array
  #       ["CDC", "CDE"]
  #     end
  #     def subject.initial_route_array=(arg)
  #       arg
  #     end
  #     subject.traversal.must_equal ["CDC", "CDE"]

  #   end
  # end

  # describe '#concat_station_to_concatenated_route_string_array' do
  #   it '应该将下一个站点加入到 concatenated_route_string_array 中.' do
  #     def subject.routes_hash
  #       {
  #         "A"=>["AB", "AD", "AE"],
  #         "B"=>["BC"],
  #         "C"=>["CD", "CE"],
  #         "D"=>["DC", "DE"],
  #         "E"=>["EB"]
  #       }
  #     end
  #     def subject.concatenated_route_string_array
  #       ["A"]
  #     end
  #     subject.concat_station_array.must_equal ["AAB", "AAD", "AAE"]
  #   end

  # describe '#search_route' do
  #   it 'should output 3 times 100.' do
  #     # 这里如果使用类实例变量, 能否测试这个效果?
  #     def subject.train_station_count
  #       3
  #     end
  #     def subject.concatenated_route_array=(arg)
  #       print "100"
  #     end
  #     def subject.concat_station_array
  #       100
  #     end
  #     def subject.concatenated_route_array
  #       ["AABDDEFFC"]
  #     end
  #     def subject.route
  #       ["AC"]
  #     end
  #     skip
  #     -> { subject.search_route }.must_output "100100100"
  #     subject.search_route.must_equal ["ABDEFC"], '.'
  #   end
  # end
end

# ============================== 功能测试 ==============================
describe TrainRouteSubject do
  before do
    @subject = TrainRouteSubject.new
    @subject.graphs = %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7)
  end

  specify { "ABC".train_route_distance.must_equal 9 }
  specify { "AD".train_route_distance.must_equal 5 }
  specify { "ADC".train_route_distance.must_equal 13 }
  specify { "AEBCD".train_route_distance.must_equal 22 }
  specify { "AED".train_route_distance.must_equal 'NO SUCH ROUTE' }

  it "应该返回从 C 到 C, 长度不超过 3 的路由" do
    @subject.route = "CC"
    expected = %w{CDC CEBC}
    @subject.search_route_while_stop {|stop| stop <= 3 }.must_equal expected
  end

  it "应该返回从 A 到 C, 长度等于 4 的路由" do
    @subject.route = "AC"
    expected = %w{ABCDC ADCDC ADEBC}
    @subject.search_route_while_stop {|stop| stop == 4 }.must_equal expected
  end

  it "应该返回从 A 到 C 的最短路由" do
    @subject.route = "AC"
    @subject.search_route.map(&:train_route_distance).min.must_equal 9
  end

  it "应该返回从 B 到 B 的最短路由" do
    @subject.route = "BB"
    @subject.search_route.map(&:train_route_distance).min.must_equal 9
  end

  it "应该返回从 C 到 C, 距离小于 30 的所有路由" do
    @subject.route = "CC"
    expected = ["CDC", "CEBC", "CDEBC", "CDCEBC", "CEBCDC", "CEBCEBC", "CEBCEBCEBC"]
    @subject.search_route_while_distance {|distance| distance < 30 }.must_equal expected
  end
end
