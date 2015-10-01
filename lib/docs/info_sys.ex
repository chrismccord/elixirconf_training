defmodule Docs.InfoSys do

  @backends [Docs.InfoSys.Wolfram]

  def start_link(backend, opts) do
    backend.start_link(opts)
  end

  def compute_img(expr) do
    @backends
    |> Enum.map(fn backend ->
      Supervisor.start_child(Docs.InfoSys.Supervisor, [backend, [
        client_pid: self,
        expr: expr
      ]])
    end)
    |> Enum.map(fn
      {:ok, pid} -> {Process.monitor(pid), pid}
      _ -> nil
    end)
    |> Enum.map(&receive_results(&1))
    |> Enum.filter(&(&1))
    |> Enum.sort_by(fn result -> result.score end, &>/2)
  end

  defp receive_results({ref, pid}) do
    result =
      receive do
        {:result, ^pid, result} -> result
        {:noresult, ^pid} -> nil
        {:DOWN, _ref, :process, ^pid, _} -> nil
      after 5000 -> nil
      end

    Process.demonitor(ref)

    receive do
      {:DOWN, _ref, :process, ^pid, _} -> nil
    after 0 -> nil
    end

    result
  end
end
