class RemoteResourceValidator < ActiveModel::Validator

  def validate record
    if record.new_record?
      record.do_request      
    else
      record.do_request :put
    end
    record.after_request_processing
  end
  
end
