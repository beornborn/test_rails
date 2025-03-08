export function calculateVotePercentages(voteCounts) {
  if (!voteCounts || Object.keys(voteCounts).length === 0) {
    return {};
  }

  const totalVotes = Object.values(voteCounts).reduce((total, count) => total + (count || 0), 0);
  if (totalVotes === 0) {
    return {};
  }

  const percentages = {};
  let remainingPercentage = 100;
  const sortedByVotes = Object.entries(voteCounts).sort(
    (first, second) => (second[1] || 0) - (first[1] || 0)
  );

  sortedByVotes.forEach(([option, votes], index) => {
    if (index === sortedByVotes.length - 1) {
      percentages[option] = Number(remainingPercentage.toFixed(1));
    } else {
      const percentage = Number((((votes || 0) * 100) / totalVotes).toFixed(1));
      percentages[option] = percentage;
      remainingPercentage -= percentage;
    }
  });

  return percentages;
}
