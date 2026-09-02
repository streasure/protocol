package commonstruct

import (
	"fmt"

	"google.golang.org/protobuf/proto"
)

// MarshalFrame serializes a business protobuf into the common client frame.
func MarshalFrame(cmd int32, seqID int64, body proto.Message) ([]byte, error) {
	bodyData, err := proto.Marshal(body)
	if err != nil {
		return nil, err
	}
	return proto.Marshal(&MessageFrame{Cmd: cmd, SeqId: seqID, Body: bodyData})
}

// UnmarshalFrame decodes the common client frame and returns its envelope.
func UnmarshalFrame(data []byte) (*MessageFrame, error) {
	frame := new(MessageFrame)
	if err := proto.Unmarshal(data, frame); err != nil {
		return nil, err
	}
	if frame.Cmd == 0 || len(frame.Body) == 0 {
		return nil, fmt.Errorf("invalid message frame")
	}
	return frame, nil
}
