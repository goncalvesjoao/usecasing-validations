module UseCase
  
  class GroupValidator < Base

    def perform
      usecases_vs_results = {}

      self.class.group_dependencies.each do |usecase|
        usecases_vs_results[usecase.to_s] = usecase.perform(context_to_hash).success?
      end

      usecases_vs_results.each do |usecase_name, result|
        failure(usecase_name, :failed) unless result
      end
    end

    def self.depends_all(*new_dependencies)
      group_dependencies.push(*new_dependencies)
    end


    protected ####################### PROTECTED #################
    
    def context_to_hash
      context.instance_variable_get('@values')
    end

    def self.group_dependencies
      @group_dependencies ||= []
    end

  end

end
