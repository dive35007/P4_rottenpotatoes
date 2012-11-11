require 'spec_helper'

describe MoviesHelper do
  describe 'oddness' do
    it 'return correct oddness for odd number' do
      oddness(3).should == 'odd'
    end
    it 'return correct oddness for even number' do
      oddness(4).should == 'even'
    end
  end
end
