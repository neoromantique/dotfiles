.pragma library

function clamp(value, minValue, maxValue) {
  if (value < minValue)
    return minValue
  if (value > maxValue)
    return maxValue
  return value
}

function workspaceRenameX(delegateX, barOuterMargin, rowInnerMargin, popupWidth, panelWidth) {
  var raw = barOuterMargin + rowInnerMargin + delegateX
  var maxX = Math.max(0, panelWidth - popupWidth)
  return Math.round(clamp(raw, 0, maxX))
}
