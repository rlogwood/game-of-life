
def reaching_steady_state(change_count)
  #steady_state_num_changes = 10
  num_found = 0

  #p change_count

  if change_count.length > STEADY_STATE_ITERATIONS
    count = change_count[change_count.length - 1]
    last_iterations_counts = change_count.slice(-STEADY_STATE_ITERATIONS, change_count.length)

    same = true

    last_iterations_counts.reverse!
    p last_iterations_counts

    # last_iterations_counts.each do |value|
    #   same &&= (value == count)
    #   break unless same
    #   num_found += 1
    # end

    first = true
    base_a = nil
    base_b = nil

    last_iterations_counts.each_slice(2) do |a, b|

      if first
        base_a = a
        base_b = b
        first = false
        a = nil
        b = nil
      else
        same &&= (base_a == a) && (base_b == b)
        break unless same
      end

      puts "base_a:(#{base_a}) base_b:(#{base_b}) a:(#{a}) b:(#{b}) num_found:(#{num_found})"
      num_found += 1
    end

  end
  #puts "num_found = (#{num_found})"
  [num_found >= SLOW_AFTER_STEADY_STATE_ITERATIONS / 2, num_found >= STEADY_STATE_ITERATIONS / 2]
end
