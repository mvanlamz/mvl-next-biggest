# mvl-next-biggest
Find the next biggest number by rearranging the digits.

During a job interview, I was presented with a problem, and given 20 minutes
to write a Ruby script to solve it.

The problem is this: 
  1. Given any integer, rearrange the digits to find the next highest integer. 
  2. Return -1 if the digits are already arranged as the highest integer possible.

There are two solutions here -- one that uses a brute force algorithm, and one that is much more efficient.

Brute Force Algorithm
During the interview, I proposed a solution in which we would generate all the permutations of the digits in the given number, sort the permutations, find the given number in the sorted set, then return the "next" number. However, a second brute force algorithm occurred to me later. This one is even easier to implement, since Ruby has such handy methods for manipulating arrays.
  1. Determine the highest number possible for a given set of digits by sorting the digits from high to low.
  2. Iterate over the range of numbers from n+1 to the maximum, and detect the first number that uses the same set of digits.

For many numbers, this second brute force algorithm is reasonably fast, too. For example, given 1234, the next number using those digits is 1243, only 9 iterations away. The worst case for a 4 digit number is 1999, since 9199 is 7200 iterations away. It can solve for 199_999 in 5 seconds, and for 1_999_999 in 50 seconds.

Efficient Algorithm
An algorithm to find the permutation of the digits in a number that results in the next highest number occurred to me the day after the job interview, when I first woke up the next morning. A single digit can only represent one number. A two digit number, where the digits are different, can represent two numbers, because there are two permutations. For example, the number 12 consists of the set [1,2], and can be either 12 or 21.

For a 3 digit number, like [1,2,3], the smallest is 123 and the largest is 321. Here are all the permutations, in order from smallest to largest:
  - 123
  - 132
  - 213
  - 231
  - 312
  - 321

How do we go from 123 to 132? At first glance, I thought maybe a recursive algorithm would work, where we consider '23', and swap the digits to '32', but going from 132 to 213 is a different transformation. By rearranging digits, how does a number get larger? It looks like there is a simple rule that a number is larger when higher digits move to the left, or lower digits move to the right. So what algorithm can we use to do this?

Tentative Steps:
  1. Consider the two right-most digits. If they are minimally sorted, then swap them.
  2. If the two right-most digits are maximally sorted, then consider the three right-most digits.
  3. If the three right-most digits are not maximally sorted, then for the left-most digit, find the smallest number to its right, which is also higher then the left-most digit. Move that digit to the left of the left-most digit, then minimally sort the numbers on the right from lowest to highest.

After implementation, I realized that step 1 is not needed, since the rule applies to two-digit numbers as well, so here is the final algorithm.

Steps:
  1. Consider the two right-most digits.
  2. If they are maximally sorted, then consider the three right-most digits.
  3. Keep examining larger and larger sub-sets, from right-to-left, until you find a sub-set that is not maximally sorted.
  4. For that subset, compare the left-most digit to all the other digits on the right.
  5. Select the digit on the right which is both the smallest of all the right-most digits, and also higher than the left-most digit.
  6. Make this digit the new left-most digit, and sort all the digits to the right, from lowest to highest.

Example: 1942
  - [1,9,4,2]
  - right-most set, [4,2], is already maximized
  - next right-most set, [9,4,2], is already maximized
  - next right-most set, [1,9,4,2], is not maximized
    - left-most digit: 1
    - smallest digit on right, [9,4,2], which is greater than 1: 2
    - move 2 to the left, and sort all other numbers on the right: [2,1,4,9]
