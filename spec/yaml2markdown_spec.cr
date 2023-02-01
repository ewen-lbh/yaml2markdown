require "./spec_helper"
require "../src/yaml2markdown"

describe YAML2Markdown do
  it "forbids unknown styles" do
    (YAML2Markdown.validate_style "lists").should eq(true)
    (validat_style "ogijreog").should eq(false)
  end
end
