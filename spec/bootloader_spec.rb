require 'spec_helper'

describe Bootloader do

  describe "#logger" do
    let(:message) { 'Test Me!' }

    context "stdout" do
      subject { capture(:stdout) { Bootloader.logger.info(message) } }
      it { should include message }
    end

    context "file" do
      let(:filename) { 'test_logger' }
      before  { Bootloader.logger(filename).info(message) }
      after   { File.delete(filename) }
      subject { File.read(filename) }
      it { should include message }
    end

    context "format block" do
      subject { capture(:stdout) { Bootloader.logger { |_, _, _, _| message }.info('nothing') } }
      it { should include message }
    end
  end

  describe "#syslogger" do
    let(:name) { 'bootloader' }
    before { Bootloader.syslogger(name).info(message) }
    pending
  end

end

