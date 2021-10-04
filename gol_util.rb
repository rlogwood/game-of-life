def steady_state_check(change_counts)
  slow_down = false, finished = false
  CYCLE_DEPTH_LENGTH_CHECKS.each do |depth|
    slow_down, finished = stead_state_check_for_depth(change_counts, depth,
                                                      STEADY_STATE_ITERATIONS, SLOW_AFTER_STEADY_STATE_ITERATIONS)
    break if slow_down || finished
  end

  [slow_down, finished]
end

def stead_state_check_for_depth(change_counts, cycle_depth, steady_iterations_count, slow_after_iterations_count)
  num_cycles_found = 0

  slice_size = steady_iterations_count * cycle_depth
  if change_counts.length > slice_size

    last_iterations_counts = change_counts.slice(-slice_size, change_counts.length)

    last_iterations_counts.reverse!

    first = true

    base_cycle = nil
    last_iterations_counts.each_slice(cycle_depth) do |cycle|
      if first
        base_cycle = cycle
        first = false
      else
        same = base_cycle.each_with_index.detect { |chg_count, idx| chg_count != cycle[idx] }.nil?
        break unless same
      end
      num_cycles_found += 1
    end
  end

  slow_down = num_cycles_found >= slow_after_iterations_count / cycle_depth
  finished = num_cycles_found >= steady_iterations_count / cycle_depth

  [slow_down, finished]
end
