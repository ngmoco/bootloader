require 'stringio'

# http://rails-bestpractices.com/questions/1-test-stdin-stdout-in-rspec
def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end
  result
end
