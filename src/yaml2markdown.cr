require "docopt"
require "yaml"

VERSION = "0.1.0"
USAGE   = <<-doc
Convert YAML files to markdown files

Usage:
  yaml2markdown [INPUT [OUTPUT]] [options]

Options:
  --using=STYLE   Style to use to render YAML objects.
                  Available values:
                  • [default: lists] — Use lists only (- **key**: value)
                  • tables           — Use GFM-style tables

Arguments:
  INPUT            Specify file to use as input. Defaults to stdin.
  OUTPUT           Specify file to write the result to. Defaults to stdout.
doc

enum Style
  Lists
  Tables
  Definitions
end

args = Docopt.docopt(USAGE)
selected_style = args["--using"].as String
input_filename = args["INPUT"]

input_file = if input_filename
               File.open(input_filename.as String)
             else
               STDIN
             end

data = YAML.parse(input_file)
rendered = render(data, selected_style, -1)

if args["OUTPUT"]
  File.write(args["OUTPUT"].as String, rendered)
else
  puts rendered
end

def render(o, style : String, indent : Int) : String?
  if o.is_a? Hash
    render_hash o, style, indent
  elsif o.as_h?
    render_hash o.as_h, style, (indent + 1)
  elsif o.as_a?
    render_array o.as_a, style, (indent + 1)
  elsif o.as_time?
    o.as_time.to_s "%F %T"
  elsif o.to_s =~ /\n/
    lines = (["", "```"] + o.to_s.split("\n") + ["```"]).join("\n" + "\t" * (indent+1))
  else
    o.to_s
  end
end

def render_array(o : Array(YAML::Any), style : String, indent : Int) : String?
  result = [""] # initial newline
  o.each { |item| result << "- #{render(item, style, indent)}" }
  result.join ("\n" + "\t" * indent)
end

def render_hash(o : Hash(YAML::Any, YAML::Any), style : String, indent : Int) : String?
  result : String = ""
  case style
  when "lists"
    lines = [""]
    o.each { |key, value|
      lines << "- **#{key}**: #{render(value, style, indent)}"
    }
    return lines.join ("\n" + "\t" * indent)
  when "tables"
    # header
    result = "|"
    o.each_key { |key|
      result += key.to_s + "|"
    }
    # separator
    result += "\n|"
    o.each_key { |key|
      result += "-" * key.to_s.size + "|"
    }
    # values
    result += "\n|"
    o.each { |key, value|
      result += "%#{key.to_s.size}s|" % render(value, style, indent)
    }
    return result + "\n"
  when "definitions"
    puts "Not Implemented"
  else
    puts "Unknown style #{style}"
  end
end
