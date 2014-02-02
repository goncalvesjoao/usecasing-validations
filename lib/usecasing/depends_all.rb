module UseCase
  
  class DependsAll < Base

    private ######################### PRIVATE ######################

    def self.tx(execution_order, context)
      ctx = Context.new(context)
      executed = []
      execution_order.each do |usecase|
        # break unless ctx.success?
        executed.push(usecase)
        yield usecase, ctx
      end
      rollback(executed, ctx) unless ctx.success?
      ctx
    end

  end

end
