require "paperclip"
require "pathname"
module Paperclip
  class PdfToSwf < Processor

    attr_accessor :file, :params, :format

    def initialize file, options = {}, attachment = nil
      super
      @file           = file
      @params         = options[:params]
      @current_format = File.extname(@file.path)
      @basename       = File.basename(@file.path, @current_format)
      @format         = options[:format]
    end

    def make
      src = @file
      temp_dst = Tempfile.new([@basename, "%.swf"])
      @file_name = Pathname(@attachment.path).basename
      @name = @file_name.to_s.split('.')
      dst = File.new((File.expand_path(Rails.root) + "/public/system/swf_pdfs/" + @name[0].downcase + "%.swf"), "w")
      begin
      parameters = []
      parameters << @params
      parameters << ":dest "
      parameters << ":source"

      parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")

      Paperclip.run("pdf2swf", parameters, :dest => "#{File.expand_path(dst.path)}", :source => File.expand_path(src.path))
    rescue Cocaine::CommandLineError => e
      raise PaperclipError, "There was an error converting #{@basename} to swf."
    end
    dst
  end

end
end