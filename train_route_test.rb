#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 求职者: 郑伟 zw963@163.com
# 问题选择: TRAINS
# 语言: Ruby 1.93

require 'minitest/autorun'
# require 'awesome_print'
require 'minitest/pride'
require_relative "train_route"

describe TrainPath do

  before do
    graph = %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7)
    @subject = TrainPath.new(graph)
  end

  describe 'test case.' do
    specify { @subject.path = "ABC"; @subject.path_distance.must_equal 9, "." }
    specify { @subject.path = "AD"; @subject.path_distance.must_equal 5, "." }
    specify { @subject.path = "ADC"; @subject.path_distance.must_equal 13, "." }
    specify { @subject.path = "AEBCD"; @subject.path_distance.must_equal 22, "." }
    specify { @subject.path = "AED"; @subject.path_distance.must_equal "NO SUCH ROUTE", "." }
  end
  
  describe 'instance method' do
    describe '#path_exist?' do
      it 'must return false' do
        @subject.path = "ACBD"
        refute @subject.path_exist?
      end

      it 'must return true' do
        @subject.path = "ADCDE"
        assert @subject.path_exist?
      end
    end

    describe '#path_distance' do
      describe 'when path_exist? is false' do
        it 'must return a error message' do
          def @subject.path_exist?
            false
          end
          @subject.path = "ACBD"
          @subject.path_distance.must_equal "NO SUCH ROUTE", "."
        end
      end

      describe 'when route_exist? is true' do
        it 'must equal 14' do
          def @subject.route_exist?
            true
          end

          def @subject.path_array
            ["AE", "EB", "BC"]
          end

          @subject.path_distance.must_equal 14, "."
        end
      end
    end
  end
end

describe TrainRoute do

  before do
    graph = %w(AC5 BC4 CD8 DC8 DE6 AD10 CE2 EB3 AE7)
    @subject = TrainRoute.new(graph)
  end

  describe 'test case' do
    describe "the number of trips from C to C with a maximum of 3 stops." do
      it 'must equal 2' do
        @subject.route = "CC";
        @subject.routes_while_stop {|e| e <= 3 }.must_equal 2, "."
      end
    end

    describe 'the number of routes from A to C with exactly 4 stops' do
      it "must equal ABCDC ADCDC ADEBC" do
        @subject.route = "AC"
        @subject.routes_while_stop(4).must_equal 3, "."
      end
    end

    describe 'the length of shortest route from A to C.' do
      it 'must equal 9' do
        @subject.route = "AC"
        @subject.routes_distance.min.must_equal 9, "."
      end

      describe 'the length of shortest route from B to B.' do
        it 'must equal 9' do
          @subject.route = "BB"
          @subject.routes_distance.min.must_equal 9, "."
        end
      end
    end

    describe 'the number of different routes from C to C with a distance of less than 30' do
      it 'must equal 7' do
        @subject.route = "CC"
        # 设置 parse 终止条件.
        @subject.routes_while_distance {|distance| distance < 30 }.must_equal 7, "."
      end
    end
  end

  describe 'instance method' do
    describe '#paths_distance_hash' do
      subject { TrainRoute.new(%w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7)) }

      it 'must equal _expected_result' do
        _expected_result =
          {
          "AB"=>"5", "BC"=>"4", "CD"=>"8",
          "DC"=>"8", "DE"=>"6", "AD"=>"5",
          "CE"=>"2", "EB"=>"3", "AE"=>"7"
        }
        subject.path_distance_hash.must_equal _expected_result, "."
      end
    end

    describe '#route_path_hash' do
      it 'must equal _expected_result' do

        # partial stub
        def @subject.paths_distance_hash
          {
            "AB"=>"5", "BC"=>"4", "CD"=>"8",
            "DC"=>"8", "DE"=>"6", "AD"=>"5",
            "CE"=>"2", "EB"=>"3", "AE"=>"7"
          }
        end

        _expected_hash =
          {
          "A"=>["AB", "AD", "AE"],
          "B"=>["BC"],
          "C"=>["CD", "CE"],
          "D"=>["DC", "DE"],
          "E"=>["EB"]
        }

        @subject.route_path_hash.must_equal _expected_hash, "."
      end
    end
    
    describe '#station_quantity' do
      it 'must equal 5' do
        @subject.station_quantity.must_equal 5, "."
      end
    end

    describe '#collect_path' do
      it 'must return matchedd path_array path' do
        @subject.route = "AC"
        array = []
        @subject.collect_path(["ABC"], array).must_equal ["ABC"], "."
        array.must_equal [["ABC"]], "."
      end
    end

    describe '#remove_collected_and_circle_path' do
      it 'must remove collected path' do
        @subject.route = "AC"
        @subject.remove_collected_and_circle_path(["ABC", "AD", "ADC", "AEBC"]).must_equal ["AD"], "."
      end

      it 'must remove circle path' do
        @subject.route = "AC"
        @subject.remove_collected_and_circle_path(["AECD", "ADCBA"]).must_equal ["AECD"], "."
      end
    end

    describe '#routes' do
      it 'return matched routes, one path only once.' do
        @subject.route = "AC"
        @subject.routes.must_equal ["ABC", "ADC", "AEBC", "ADEBC"], "."
      end
    end

    describe '#concat_path' do
      it 'concat all valid path from start to end into a string.' do
        def @subject.route_path_hash
          {
            "A"=>["AB", "AD", "AE"],
            "B"=>["BC"],
            "C"=>["CD", "CE"],
            "D"=>["DC", "DE"],
            "E"=>["EB"]
          }
        end
        @subject.concat_path("AC").must_equal ["ACD", "ACE"], "."
      end
    end

    describe '#Distance' do
      it 'must equal 9' do
        @subject.Distance("ABC").must_equal 9, "."
      end
    end
  end
end
