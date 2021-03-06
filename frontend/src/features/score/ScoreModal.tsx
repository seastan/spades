import React from "react";
import ReactModal from "react-modal";
import Button from "../../components/basic/Button";
import ScoreTable from "./ScoreTable";

interface Props {
  isOpen: boolean;
  closeModal: () => void;
}

ReactModal.setAppElement("#root");

export const ScoreModal: React.FC<Props> = ({ isOpen, closeModal }) => {
  return (
    <ReactModal
      closeTimeoutMS={200}
      isOpen={isOpen}
      onRequestClose={closeModal}
      contentLabel="Score Sheet"
      overlayClassName="fixed inset-0 bg-black-50 z-50"
      className="insert-auto overflow-auto p-5 bg-gray-100 border max-w-lg mx-auto my-12 rounded-lg outline-none"
    >
      <h1>Score</h1>
      <ScoreTable />
      <Button onClick={closeModal} className="">
        OK
      </Button>
    </ReactModal>
  );
};
export default ScoreModal;
