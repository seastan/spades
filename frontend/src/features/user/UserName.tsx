import React, { useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import { fetchUser } from "./usersSlice";
import useAuth from "../../hooks/useAuth";
import { RootState } from "../../rootReducer";

interface Props {
  userID: number | null;
  defaultName?: String | null;
}

export const UserName: React.FC<Props> = ({ userID, defaultName }) => {
  const dispatch = useDispatch();
  const authContext = useAuth();
  useEffect(() => {
    if (userID == null) {
      return;
    }
    dispatch(fetchUser(userID, authContext));
  }, [authContext, dispatch, userID]);

  const user = useSelector(
    (state: RootState) => state.users.usersById[userID || 0]
  );

  if (userID === null) {
    return <span>{defaultName ? defaultName : "anonymous"}</span>;
  } 
  if (userID < 0) {
    return null;
  } 
  if (user != null) {
    return <span>{user.alias}</span>;
  }
  return <div>user #{userID}</div>;
};
export default UserName;
