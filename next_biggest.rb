require "minitest/autorun"


class Permute
  def next_biggest(n)
    # From right-to-left, consider larger and larger sets until we find a set
    # that is not maximum sorted. 
    left = n.to_s.split('')  # [1,2,3]
    right = []
    right.unshift left.pop  # [1,2,3],[] -> [1,2],[3]
    while left.size > 0
      right.unshift left.pop  # [1,2],[3] -> [1],[2,3]
      result = rearrange(right.join)  # pass a string to handle "01"
      if result != -1
        return "#{left.join}#{result}".to_i
      end
    end
    -1  # value cannot be increased by rearranging digits
  end

  def rearrange(n)
    # In general, the value of a number increases when we rearrange the digits
    # by moving lower digits to the right, and higher digits to the left.
    # 
    # For the minimum number, the digits are ascending: 12345
    # For the maximum, the digits are descending: 54321
    #
    # To find the "next" highest number, rearrange the smallest set of digits which
    # are not maximally sorted. Consider the left-most digit, and from the set of digits
    # on the right, find the set of digits which are greater than the left-most digit,
    # and from that set, choose the lowest, and move it to the left of the original
    # left-most digit, then sort the remaining set on the right, from lowest to highest.
    # Examples: 132, left: 1, right: 32, next: 2, return 213
    #           23, left: 2, right: 3, return 32
    #           32, left: 3
    #           2322211, left: 2, right 322211, return 
    left = []
    right = n.to_s.split('')  # [],[1,9,4,2]
    left_most = right.shift  # 1 [9,4,2]
    next_highest = right.sort.detect{|x| x > left_most}  # [9,4,2], so 2
    return -1 if next_highest.nil?  # cannot be rearranged to form a larger number
    right = yoink(right, next_highest).sort  # [4,9]
    right.push left_most  # [4,9,1]
    "#{next_highest}#{right.sort.join}".to_i  # 2149
  end

  def yoink(arr, n)
    # Remove the given value from the array, and return the array.
    i = arr.index n
    arr[i] = nil
    arr.compact
  end

  def next_brutest(n)
    max = n.to_s.split('').sort.reverse  # no number higher than reverse sorted digits: 54321
    return -1 if n == max.join.to_i
    # Test every integer from n+1 to the max and return the first with matching digits.
    bigger = ((n + 1)..(max.join.to_i)).detect{|x| max == x.to_s.split('').sort.reverse}
    bigger || -1
  end
end


class TestPermute < Minitest::Test
  def setup
    @permute = Permute.new
  end

  def test_both_functions_match
    (0..1000).map do |x|
      assert_equal @permute.next_biggest(x), @permute.next_brutest(x)
    end
  end

  def test_detect_optimally_sorted
    assert_equal -1, @permute.next_biggest(0)
    assert_equal -1, @permute.next_biggest(73)
    assert_equal -1, @permute.next_biggest(321)
    assert_equal -1, @permute.next_biggest(420)
    assert_equal -1, @permute.next_biggest(4444)
    assert_equal -1, @permute.next_biggest(99991)
  end

  def test_find_the_next_biggest_number
    assert_equal 42, @permute.next_biggest(24)
    assert_equal 73, @permute.next_biggest(37)
    assert_equal 110, @permute.next_biggest(101)
    assert_equal 201, @permute.next_biggest(120)
    assert_equal 132, @permute.next_biggest(123)
    assert_equal 213, @permute.next_biggest(132)
    assert_equal 231, @permute.next_biggest(213)
    assert_equal 312, @permute.next_biggest(231)
    assert_equal 432, @permute.next_biggest(423)
    assert_equal 546, @permute.next_biggest(465)
    assert_equal 7546, @permute.next_biggest(7465)
    assert_equal 1243, @permute.next_biggest(1234)
    assert_equal 1324, @permute.next_biggest(1243)
    assert_equal 1342, @permute.next_biggest(1324)
    assert_equal 1423, @permute.next_biggest(1342)
    assert_equal 11230, @permute.next_biggest(11203)
    assert_equal 41232, @permute.next_biggest(41223)
    assert_equal 451232, @permute.next_biggest(451223)
  end

  def test_it_can_handle_very_large_numbers
    assert_equal 192837546, @permute.next_biggest(192837465)
    assert_equal 91999999999999, @permute.next_biggest(19999999999999)
    assert_equal 1111111111111191, @permute.next_biggest(1111111111111119)
  end

  def test_brute_force_does_the_trick
    assert_equal 42, @permute.next_brutest(24)
    assert_equal 73, @permute.next_brutest(37)
    assert_equal -1, @permute.next_brutest(0)
    assert_equal -1, @permute.next_brutest(7)
    assert_equal -1, @permute.next_brutest(32)
    assert_equal -1, @permute.next_brutest(42)
    assert_equal -1, @permute.next_brutest(73)
    assert_equal -1, @permute.next_brutest(22)
    assert_equal -1, @permute.next_brutest(333)
    assert_equal -1, @permute.next_brutest(44440)
    assert_equal -1, @permute.next_brutest(9876543210)
    assert_equal 132, @permute.next_brutest(123)
    assert_equal 1132, @permute.next_brutest(1123)
    assert_equal 1232, @permute.next_brutest(1223)
    assert_equal 41232, @permute.next_brutest(41223)
    assert_equal 451232, @permute.next_brutest(451223)
    assert_equal 1322, @permute.next_brutest(1232)
    assert_equal 9199, @permute.next_brutest(1999)
    assert_equal 192837546, @permute.next_brutest(192837465)
    assert_equal 1111111111111191, @permute.next_brutest(1111111111111119)
  end

  def test_brute_force_does_the_trick_eventually
    skip "these tests take a long time to run"
    assert_equal 919999, @permute.next_brutest(199999)  # takes about 5 seconds
    assert_equal 9199999, @permute.next_brutest(1999999)  # takes about 50 seconds
  end
end
