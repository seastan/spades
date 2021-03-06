import React from "react";
import { useSelector } from 'react-redux';
import { GROUPSINFO } from "./Constants";

export const TopBarViewItem = React.memo(({
  groupId,
  handleBrowseSelect,
  playerN,
}) => {
  const groupStore = state => state.gameUi.game.groupById[groupId];
  const group = useSelector(groupStore);

  const handleMenuClick = (data) => {
    if (!playerN) {
      alert("Please sit at the table first.");
      return;
    } else if (data.action === "look_at") {
      handleBrowseSelect(data.groupId);
    } 
  }

  if (!group) return;

  const stackIds = group.stackIds;
  const deckType = group.type;

  if (deckType === "play") return;

  return(
    <li className="relative cursor-pointer" onClick={() => handleMenuClick({action:"look_at",groupId:groupId})} key={groupId}>
    <a className="absolute" href="#">
    {GROUPSINFO[groupId].name}
    </a>
    <div className="absolute right-2 top-1 select-none">{stackIds.length}</div>
    </li>
  )
})