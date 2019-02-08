defmodule Images.ImageSupervisor do
  use Supervisor

  def start_link(default) do
    :supervisor.start_link(__MODULE__, default)
  end

  def init([]) do
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:workers_module, Images.ImageWorker},
      {:size, 20},
      {:max_overflow, 0}
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]
  end

  def pool_name do
    :image_workers
  end
end
