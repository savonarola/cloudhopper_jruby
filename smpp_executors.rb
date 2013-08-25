java_import 'java.util.concurrent.Executors'
java_import 'java.util.concurrent.atomic.AtomicInteger'

class SmppExecutors
  
  class ThreadFactory
    def initialize
      @sequence = AtomicInteger.new(0)
    end

    def newThread(runnable)
      java.lang.Thread.new(runnable).tap do |t|
        t.setName("SmppSessionWindowMonitorPool-#{@sequence.getAndIncrement}")
      end
    end
  end

  attr_reader :executor, :monitor_executor

  def initialize
    start
  end

  def start
    stop
    @executor = Executors.newCachedThreadPool
    @monitor_executor = Executors.newScheduledThreadPool(1, ThreadFactory.new)
  end

  def stop
    stop_executor
    stop_monitor_executor
  end

  private
  
  def stop_executor
    if @executor
      @executor.shutdownNow
      @executor = nil
    end
  end

  def stop_monitor_executor
    if @monitor_executor
      @monitor_executor.shutdownNow
      @monitor_executor = nil
    end
  end
end


