# frozen_string_literal: true

require "spec_helper"

describe "bundle exec rubocop", rubocop: true do # rubocop: disable RSpec/DescribeClass
  it "All Green in Rubocop" do
    @report = `bundle exec rubocop --config .rubocop.yml`
    expect(@report.match("Offenses")).to be_nil, "Rubocop offenses found.\n#{@report}"
  end
end
